Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120222102301.GC30339@elte.hu>
References: <20120222012103.GA13295@www.outflux.net>
	<20120222102301.GC30339@elte.hu>
Date: Wed, 22 Feb 2012 11:10:04 -0800
Message-ID: <CAGXu5jLnDa9g5z76OQaF5BGbHssQVSgc3KCSwOVT9__mLww9Yg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] fs: hardlink creation restriction cleanup
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 22, 2012 at 2:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Clean-up of hardlink restriction logic, as suggested by Andrew Morton.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> =A0fs/namei.c | =A0 59 +++++++++++++++++++++++++++++++++++++++++--------=
----------
>> =A01 files changed, 41 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 8ed4e00..a4a21a5 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -693,46 +693,69 @@ static inline int may_follow_link(struct path *lin=
k)
>> =A0}
>>
>> =A0/**
>> + * safe_hardlink_source - Check for safe hardlink conditions
>> + * @inode: the source inode to hardlink from
>> + *
>> + * Return false if at least one of the following conditions:
>> + * =A0 =A0- inode is not a regular file
>> + * =A0 =A0- inode is setuid
>> + * =A0 =A0- inode is setgid and group-exec
>> + * =A0 =A0- access failure for read and write
>> + *
>> + * Otherwise returns true.
>> + */
>> +static bool safe_hardlink_source(struct inode *inode)
>> +{
>> + =A0 =A0 mode_t mode =3D inode->i_mode;
>> +
>> + =A0 =A0 /* Special files should not get pinned to the filesystem. */
>> + =A0 =A0 if (!S_ISREG(mode))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 /* Setuid files should not get pinned to the filesystem. */
>> + =A0 =A0 if (mode & S_ISUID)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 /* Executable setgid files should not get pinned to the filesy=
stem. */
>> + =A0 =A0 if ((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_IXGRP))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> + =A0 =A0 /* Hardlinking to unreadable or unwritable sources is dangerou=
s. */
>> + =A0 =A0 if (inode_permission(inode, MAY_READ | MAY_WRITE))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> +
>> + =A0 =A0 return true;
>
> A really minor nitpick, could we use this form please:
>
> static bool safe_hardlink_source(struct inode *inode)
> {
> =A0 =A0 =A0 =A0mode_t mode =3D inode->i_mode;
>
> =A0 =A0 =A0 =A0/* Special files should not get pinned to the filesystem. =
*/
> =A0 =A0 =A0 =A0if (!S_ISREG(mode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>
> =A0 =A0 =A0 =A0/* Setuid files should not get pinned to the filesystem. *=
/
> =A0 =A0 =A0 =A0if (mode & S_ISUID)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>
> =A0 =A0 =A0 =A0/* Executable setgid files should not get pinned to the fi=
lesystem. */
> =A0 =A0 =A0 =A0if ((mode & (S_ISGID | S_IXGRP)) =3D=3D (S_ISGID | S_IXGRP=
))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>
> =A0 =A0 =A0 =A0/* Hardlinking to unreadable or unwritable sources is dang=
erous. */
> =A0 =A0 =A0 =A0if (inode_permission(inode, MAY_READ | MAY_WRITE))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return false;
>
> =A0 =A0 =A0 =A0return true;
> }
>
> Those separate blocks of comments and conditions stand out much
> nicer this way, making it way easier on the eyes - to my eyes at
> least ;-)

Heh, sure. I've sent v2 now. :)

-Kees

--=20
Kees Cook
ChromeOS Security
