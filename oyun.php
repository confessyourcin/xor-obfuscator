<?php
if (isset($_GET['sonuc'])) {
    $sonuc = $_GET['sonuc'];
    $decodedString = base64_decode($sonuc);
    $lines = explode("\n", $decodedString);
    $firstLine = trim($lines[0]);
} else {
    $decodedString = "No base64 code provided.";
    $firstLine = "NoFileName";
}

// Function to force download a string as a file
function forceDownload($filename, $content) {
    header('Content-Disposition: attachment; filename="' . $filename . '"');
    header('Content-Type: text/plain');
    echo $content;
    exit;
}

if (isset($_GET['download'])) {
    $downloadFilename = ($firstLine !== "") ? $firstLine . ".txt" : "decoded_result.txt";
    forceDownload($downloadFilename, $decodedString);
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>ㅤ</title>
</head>
<body>
    <?php if ($decodedString !== "No base64 code provided."): ?>
        <form method="get" action="">
            <input type="hidden" name="sonuc" value="<?php echo $sonuc; ?>">
            <input type="hidden" name="download" value="true">
            <button type="submit">Sonucu Kaydet</button>
        </form>
    <?php endif; ?>
    <pre><?php echo htmlspecialchars($decodedString); ?></pre>
</body>
</html>
