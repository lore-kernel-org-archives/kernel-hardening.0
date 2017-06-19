MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5j+LSrLzZSWLozjGvjEQV6P-Mgsj9Fgdp9wuiFxV=JrYgA@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-8-git-send-email-keescook@chromium.org> <20170528081249.GD22193@infradead.org>
 <CAGXu5j+LSrLzZSWLozjGvjEQV6P-Mgsj9Fgdp9wuiFxV=JrYgA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 12:24:13 -0700
Message-ID: <CAGXu5jKxFZ17-XuFDxz=qr9o_7KXLg2dh_krN=OQQ+1bFP=qqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 07/20] randstruct: Whitelist big_key path struct overloading
To: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 28, 2017 at 9:59 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, May 28, 2017 at 1:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> What about the untested patch below to just fix the issue?
>>
>> ---
>> From e9eb519c854d2f3d16a4def492577a883246e290 Mon Sep 17 00:00:00 2001
>> From: Christoph Hellwig <hch@lst.de>
>> Date: Sun, 28 May 2017 11:03:34 +0300
>> Subject: security/keys: don't cast union key_payload
>>
>> Instead store the individual pointers in struct path.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Yeah, this is less invasive than what I'd proposed to David to fix it
> earlier. David, does this look okay to you?
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

David, if you can Ack this, I'll carry it in my tree.

Thanks!

-Kees

>
> -Kees
>
>> ---
>>  security/keys/big_key.c | 35 ++++++++++++++++++++---------------
>>  1 file changed, 20 insertions(+), 15 deletions(-)
>>
>> diff --git a/security/keys/big_key.c b/security/keys/big_key.c
>> index 835c1ab30d01..06f2cd07dbd7 100644
>> --- a/security/keys/big_key.c
>> +++ b/security/keys/big_key.c
>> @@ -26,8 +26,8 @@
>>   */
>>  enum {
>>         big_key_data,
>> -       big_key_path,
>> -       big_key_path_2nd_part,
>> +       big_key_path_mnt,
>> +       big_key_path_dentry,
>>         big_key_len,
>>  };
>>
>> @@ -118,12 +118,16 @@ static int big_key_crypt(enum big_key_op op, u8 *data, size_t datalen, u8 *key)
>>         return ret;
>>  }
>>
>> +#define PATH_FROM_PAYLOAD(p) {                         \
>> +       .mnt    = (p)->data[big_key_path_mnt],          \
>> +       .dentry = (p)->data[big_key_path_dentry],       \
>> +}
>> +
>>  /*
>>   * Preparse a big key
>>   */
>>  int big_key_preparse(struct key_preparsed_payload *prep)
>>  {
>> -       struct path *path = (struct path *)&prep->payload.data[big_key_path];
>>         struct file *file;
>>         u8 *enckey;
>>         u8 *data = NULL;
>> @@ -190,9 +194,10 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>>                 /* Pin the mount and dentry to the key so that we can open it again
>>                  * later
>>                  */
>> +               path_get(&file->f_path);
>>                 prep->payload.data[big_key_data] = enckey;
>> -               *path = file->f_path;
>> -               path_get(path);
>> +               prep->payload.data[big_key_path_mnt] = file->f_path.mnt;
>> +               prep->payload.data[big_key_path_dentry] = file->f_path.dentry;
>>                 fput(file);
>>                 kfree(data);
>>         } else {
>> @@ -222,9 +227,9 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>>  void big_key_free_preparse(struct key_preparsed_payload *prep)
>>  {
>>         if (prep->datalen > BIG_KEY_FILE_THRESHOLD) {
>> -               struct path *path = (struct path *)&prep->payload.data[big_key_path];
>> +               struct path path = PATH_FROM_PAYLOAD(&prep->payload);
>>
>> -               path_put(path);
>> +               path_put(&path);
>>         }
>>         kfree(prep->payload.data[big_key_data]);
>>  }
>> @@ -235,13 +240,13 @@ void big_key_free_preparse(struct key_preparsed_payload *prep)
>>   */
>>  void big_key_revoke(struct key *key)
>>  {
>> -       struct path *path = (struct path *)&key->payload.data[big_key_path];
>> +       struct path path = PATH_FROM_PAYLOAD(&key->payload);
>>
>>         /* clear the quota */
>>         key_payload_reserve(key, 0);
>>         if (key_is_instantiated(key) &&
>>             (size_t)key->payload.data[big_key_len] > BIG_KEY_FILE_THRESHOLD)
>> -               vfs_truncate(path, 0);
>> +               vfs_truncate(&path, 0);
>>  }
>>
>>  /*
>> @@ -252,11 +257,11 @@ void big_key_destroy(struct key *key)
>>         size_t datalen = (size_t)key->payload.data[big_key_len];
>>
>>         if (datalen > BIG_KEY_FILE_THRESHOLD) {
>> -               struct path *path = (struct path *)&key->payload.data[big_key_path];
>> +               struct path path = PATH_FROM_PAYLOAD(&key->payload);
>>
>> -               path_put(path);
>> -               path->mnt = NULL;
>> -               path->dentry = NULL;
>> +               path_put(&path);
>> +               key->payload.data[big_key_path_mnt] = NULL;
>> +               key->payload.data[big_key_path_dentry] = NULL;
>>         }
>>         kfree(key->payload.data[big_key_data]);
>>         key->payload.data[big_key_data] = NULL;
>> @@ -290,7 +295,7 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
>>                 return datalen;
>>
>>         if (datalen > BIG_KEY_FILE_THRESHOLD) {
>> -               struct path *path = (struct path *)&key->payload.data[big_key_path];
>> +               struct path path = PATH_FROM_PAYLOAD(&key->payload);
>>                 struct file *file;
>>                 u8 *data;
>>                 u8 *enckey = (u8 *)key->payload.data[big_key_data];
>> @@ -300,7 +305,7 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
>>                 if (!data)
>>                         return -ENOMEM;
>>
>> -               file = dentry_open(path, O_RDONLY, current_cred());
>> +               file = dentry_open(&path, O_RDONLY, current_cred());
>>                 if (IS_ERR(file)) {
>>                         ret = PTR_ERR(file);
>>                         goto error;
>> --
>> 2.11.0
>>
>
>
>
> --
> Kees Cook
> Pixel Security



-- 
Kees Cook
Pixel Security
