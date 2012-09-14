<?php
    function scan($target_dir) {
        $files = array();

        $dirs = scandir($target_dir);            
        foreach ($dirs as $dir) {
            if($dir == '.' ||$dir == '..') continue;

            $dir = $target_dir . '/' . $dir;
            if(is_dir($dir)) {
                $arr = scan($dir);
                $files = array_merge($files, $arr);
            }
            else {
                $files[] = $dir;
            }
        }

        return $files;
    }
    $files = scan('/home/tony/projects/git/manual-chinese');
    foreach($files as $file) {
        $arr = explode('.', $file);
        $ext = end($arr);
        if($ext == 'txt') {
            $target = substr($file, 0, -4);            
            rename($file, "$target.asciidoc");
        }
    }
    print_r($dir);
?>