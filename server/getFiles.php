 <?php
    // open this directory 
    $Directory = opendir("/");
    // get each entry
    while ($entryName = readdir($Directory)) {
        $fileArray[] = $entryName;
    }
    // close directory
    closedir($Directory);
    echo json_encode($fileArray);
?>