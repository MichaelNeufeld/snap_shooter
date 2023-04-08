 <?php
    $Directory = opendir("./images");
    $fileArray = array();

    while ($entryName = readdir($Directory)) {
        $fileArray += $entryName;
    }

    closedir($Directory);
    echo json_encode($fileArray);
?>