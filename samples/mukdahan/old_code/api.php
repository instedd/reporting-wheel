<?php

require_once 'curl.php';
require_once 'magpierss/rss_fetch.inc';

define("BASE_API_URL", "http://geochat.instedd.org/api/");

function get_user($login) {
        $url = BASE_API_URL . "users/" . $login;
        
        $content = get_http_url($url);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function create_user($login, $displayname, $password) {
        $url = BASE_API_URL . "users/" . $login . "/create";
        $data = array("displayname" => $displayname, "password" => $password);
        
        $content = post_http_url($url, $data);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function list_user_groups($login, $page = 1) {
        $url = BASE_API_URL . "users/" . $login . "/groups?page=" . $page;
        
        $credentials = _get_credentials();
        
        $content = get_http_url($url, $credentials['user'], $credentials['password']);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function get_group($alias) {
        $url = BASE_API_URL . "groups/" . $alias;
        
        $credentials = _get_credentials();
        
        $content = get_http_url($url, $credentials['user'], $credentials['password']);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function send_message_to_group($alias, $message) {
        $url = BASE_API_URL . "groups/" . $alias . "/messages";
        $data = array('message' => $message);
        $credentials = _get_credentials();
        
        // this actions doesnt return content
        post_http_url($url, $data, $credentials['user'], $credentials['password']);
        
        return;
}

function get_group_messages($alias, $page = 1) {
        $url = BASE_API_URL . "groups/" . $alias . "/messages?page=" . $page;
        $credentials = _get_credentials();
        
        $content = get_http_url($url, $credentials['user'], $credentials['password']);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function get_user_messages($login, $page = 1) {
        $url = BASE_API_URL . "users/" . $login . "/messages?page=" . $page;
        $credentials = _get_credentials();
        
        $content = get_http_url($url, $credentials['user'], $credentials['password']);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function create_group($alias, $name, $description, $hidden, $requireapproval, $chatroom, $latitude, $longitude) {
        $url = BASE_API_URL . "groups/" . $alias . "/create";
        $credentials = _get_credentials();
        $data = array('name' => $name, 'description' => $description, 
                                  'hidden' => $hidden, 'requireapproval' => $requireapproval, 
                                  'chatroom' => $chatroom, 'latitude' => $latitude, 'longitude' => $longitude);
        
        $content = post_http_url($url, $data, $credentials['user'], $credentials['password']);
        
        $rss = parse_rss($content);
        
        return $rss;
}

function _get_credentials() {
        /*if (isset($_SESSION['user'])) {
                $user = $_SESSION['user'];
                $password = $_SESSION['password'];
        } else {
                $user = '';
                $password = '';
        }
        
        return array('user' => $user, 'password' => $password);*/
		return array('user' => 'reporting-wheel-muk', 'password' => 'reporting-wheel-muk');
}

?>