# iCloud Drive + Photos via rclone (remote: iclouddrive)
# If mounting fails with "trust token expired": rclone config reconnect iclouddrive:

# icloud-mount: mount Drive at ~/iCloudDrive and Photos (read-only) at ~/iCloudPhotos.
icloud-mount () {
  if ! mountpoint -q ~/iCloudDrive; then
    \mkdir -p ~/iCloudDrive
    rclone mount iclouddrive: ~/iCloudDrive \
      --vfs-cache-mode full \
      --vfs-cache-max-age 24h \
      --dir-cache-time 5m \
      --daemon \
      --log-file ~/.cache/rclone-icloud.log --log-level INFO \
      && echo "iCloud Drive mounted at ~/iCloudDrive"
  else
    echo "iCloud Drive already mounted"
  fi

  if ! mountpoint -q ~/iCloudPhotos; then
    \mkdir -p ~/iCloudPhotos
    rclone mount "iclouddrive,service=photos:" ~/iCloudPhotos \
      --read-only \
      --vfs-cache-mode full \
      --vfs-cache-max-age 24h \
      --dir-cache-time 1h \
      --daemon \
      --log-file ~/.cache/rclone-icloudphotos.log --log-level INFO \
      && echo "iCloud Photos mounted at ~/iCloudPhotos"
  else
    echo "iCloud Photos already mounted"
  fi
}

# icloud-umount: unmount both.
icloud-umount () {
  local dir
  for dir in ~/iCloudDrive ~/iCloudPhotos; do
    mountpoint -q "$dir" && fusermount3 -u "$dir" && echo "Unmounted $dir"
  done
}
