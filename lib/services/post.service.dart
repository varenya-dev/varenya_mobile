import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_mobile/constants/endpoint_constant.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/dtos/post/create_post/create_post.dto.dart';
import 'package:varenya_mobile/dtos/post/delete_post/delete_post.dto.dart';
import 'package:varenya_mobile/dtos/post/update_post/update_post.dto.dart';
import 'package:varenya_mobile/exceptions/server.exception.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/utils/logger.util.dart';

/*
 * Service Implementation for Posts Module.
 */
class PostService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Box<List<dynamic>> _postsBox = Hive.box(VARENYA_POSTS_BOX);
  final Box<List<dynamic>> _categoriesBox = Hive.box(VARENYA_POST_CATEGORY_BOX);

  /*
   * Method to fetch a single post details from server.
   * @param postId UUID of the post.
   */
  Future<Post> fetchPostsById(String postId) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      RAW_ENDPOINT,
      "/v1/api/post",
      {"postId": postId},
    );

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:fetchPostsById Error", body['message']);
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    // Decode JSON and create object based on it.
    dynamic jsonResponse = json.decode(response.body);
    Post post = Post.fromJson(jsonResponse);

    // Return post details.
    return post;
  }

  /*
   * Method to fetch new posts from the server.
   */
  Future<List<Post>> fetchNewPosts() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/post/new");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Send the post request to the server.
      http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw ServerException(message: body['message']);
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchNewPosts Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Post> posts =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      // Save posts on device storage.
      this._savePostsToDevice(posts, "NEW");

      return posts;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage.
      return this._fetchPostsFromDevice("NEW");
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage.
      return this._fetchPostsFromDevice("NEW");
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch posts from device storage.
        return this._fetchPostsFromDevice("NEW");
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to fetch posts based on post category.
   * @param category Category the posts should belong to.
   */
  Future<List<Post>> fetchPostsByCategory(String category) async {
    try {
      // Check if new posts are to be fetched.
      if (category == 'NEW') {
        // Fetch and return new posts.
        return await this.fetchNewPosts();
      }

      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.http(
        RAW_ENDPOINT,
        "/v1/api/post/category",
        {"category": category},
      );

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Send the post request to the server.
      http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw ServerException(message: body['message']);
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchPostsByCategory Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Post> posts =
          jsonResponse.map((postJson) => Post.fromJson(postJson)).toList();

      // Save posts on device storage by category.
      this._savePostsToDevice(posts, category);

      return posts;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage by category.
      return this._fetchPostsFromDevice(category);
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage by category.
      return this._fetchPostsFromDevice(category);
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch posts from device storage by category.
        return this._fetchPostsFromDevice(category);
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to fetch categories from the server.
   */
  Future<List<PostCategory>> fetchCategories() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/post/categories");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      // Send the post request to the server.
      http.Response response = await http.get(
        uri,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        Map<String, dynamic> body = json.decode(response.body);
        throw ServerException(message: body['message']);
      } else if (response.statusCode >= 500) {
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchCategories Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<PostCategory> categories =
          jsonResponse.map((json) => PostCategory.fromJson(json)).toList();

      // Save categories on device storage.
      this._saveCategoriesToDevice(categories);

      // Return fetched categories.
      return categories;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch categories from device storage.
      return this._fetchCategoriesFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch categories from device storage.
      return this._fetchCategoriesFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch categories from device storage.
        return this._fetchCategoriesFromDevice();
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to create and save posts on server.
   * @param createPostDto DTO Object for creating posts.
   */
  Future<void> createNewPost(CreatePostDto createPostDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
      'Content-type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      body: json.encode(createPostDto.toJson()),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      print(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:createNewPost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  /*
   * Method to update and save posts on server.
   * @param updatePostDto DTO Object for updating posts.
   */
  Future<void> updatePost(UpdatePostDto updatePostDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
      'Content-type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.put(
      uri,
      body: json.encode(updatePostDto.toJson()),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:updatePost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  /*
   * Method to delete post from server.
   * @param deletePostDto DTO Object for deleting posts.
   */
  Future<void> deletePost(DeletePostDto deletePostDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.delete(
      uri,
      body: deletePostDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:deletePost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  /*
   * Method to save posts on device by categories.
   */
  void _savePostsToDevice(List<Post> posts, String category) {
    log.i("Saving Posts:$category to Device");

    // Save posts to HiveDB box by category.
    this._postsBox.put(category, posts);
    log.i("Saved Posts:$category to Device");
  }

  /*
   * Method to fetch saved posts from device by category.
   */
  List<Post> _fetchPostsFromDevice(String category) {
    log.i("Fetching Posts:$category From Device");

    // Fetch and return saved posts from device by category.
    return this._postsBox.get(category, defaultValue: [])!.cast<Post>();
  }

  /*
   * Method to save categories on device.
   */
  void _saveCategoriesToDevice(List<PostCategory> categories) {
    log.i("Saving Categories to Device");

    // Save categories to HiveDB box.
    this._categoriesBox.put(VARENYA_CATEGORY_LIST, categories);
    log.i("Saved Categories to Device");
  }

  /*
   * Method to fetch saved categories from device.
   */
  List<PostCategory> _fetchCategoriesFromDevice() {
    log.i("Fetching Categories From Device");

    // Fetch and return saved categories from device.
    return this
        ._categoriesBox
        .get(VARENYA_CATEGORY_LIST, defaultValue: [])!.cast<PostCategory>();
  }
}
