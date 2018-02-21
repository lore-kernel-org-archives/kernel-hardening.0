MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <6be06ce5-87e6-0d9d-55b9-6c70c3578ecf@maciej.szmigiero.name>
References: <CAGXu5jLc_A1w4FM8FvQHGSPjLfOu80L_vbt_FkcE6+Bh_XMjxw@mail.gmail.com>
 <6be06ce5-87e6-0d9d-55b9-6c70c3578ecf@maciej.szmigiero.name>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 21 Feb 2018 14:52:28 -0800
Message-ID: <CAGXu5j+gvH+X-XyqFbY+X0xtG2mQoL5bO7T2_QaeEyr3-Z5eLw@mail.gmail.com>
Subject: Re: RANDSTRUCT structs need linux/compiler_types.h (Was: [nfsd4]
 potentially hardware breaking regression in 4.14-rc and 4.13.11)
Content-Type: text/plain; charset="UTF-8"
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Patrick McLean <chutzpah@gentoo.org>, Linus Torvalds <torvalds@linux-foundation.org>, Emese Revfy <re.emese@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Bruce Fields <bfields@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Thorsten Leemhuis <regressions@leemhuis.info>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 2:19 PM, Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
> One can see that offsets used to access various members of struct path are
> different, and also that the original file from step 3 contains an object
> named "__randomize_layout".
>
> This is caused by a fact that the current version of nfs4xdr.c includes
> linux/fs_struct.h as the very first included header which then includes
> linux/path.h as the very first included header, which then defines
> struct path, but without including any files on its own.
>
> This results in __randomize_layout tag at the end of struct path
> definition being treated as a variable name (since linux/compiler-gcc.h
> that defines it as a type attribute has not been included yet).

Oh, well done! That would explain the code offset I was seeing when
the plugin on, but no-op, since the variable would still exist.

I'll play with Linus's suggestion and see what we get.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
