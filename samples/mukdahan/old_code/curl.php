<?php

function get_http_url($url, $user = "", $password = "") {

        $ch = create_curl_handler($url, $user, $password);
        
        // Get content
        $result = curl_exec ($ch);
        
        // Get HTTP Status Code
        $status = curl_getinfo($ch,CURLINFO_HTTP_CODE);
        
        if ($status != 200) {
                throw new Exception('Request failed: HTTP status code returned is ' . $status);
        }

        // Close session
        curl_close ($ch);

        return $result;
}

function post_http_url($url, $data, $user = "", $password = "") {

        $ch = create_curl_handler($url, $user, $password);
        
        // Make it a POST
        curl_setopt($ch, CURLOPT_POST, TRUE);
        
        // Attach data
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        
        // Get content
        $result = curl_exec ($ch);
        
        // Close session
        curl_close ($ch);

        return $result;
}

function create_curl_handler($url, $user, $password) {
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);

        // Don't return headers
        curl_setopt($ch, CURLOPT_HEADER, 0);

        // User Agent
        curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)");
        
        // Basic Auth
        if (!empty($user) && !empty($password)) {
                curl_setopt($ch, CURLOPT_USERPWD, $user . ":" . $password);
        }
        
        // return the value instead of printing the response to browser
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        return $ch;
}

?>