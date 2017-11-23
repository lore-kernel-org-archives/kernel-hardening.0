Date: Fri, 24 Nov 2017 09:57:06 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171123225706.GK12736@eros>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 22, 2017 at 09:01:46AM +0100, Salvatore Mesoraca wrote:

Same caveat about this being English language comments only as for patch
1/2. Please ignore if this is too trivial. My grammar is a long way from
perfect, especially please feel free to ignore my placement of commas,
they are often wrong. 

> Disallows O_CREAT open missing the O_EXCL flag, in world or
> group writable directories, even if the file doesn't exist yet.
> With few exceptions (e.g. shared lock files based on flock())
> if a program tries to open a file, in a sticky directory,
> with the O_CREAT flag and without the O_EXCL, it probably has a bug.
> This feature allows to detect and potentially block programs that
> act this way, it can be used to find vulnerabilities (like those
> prevented by patch #1) and to do policy enforcement.
> 
> Suggested-by: Solar Designer <solar@openwall.com>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  Documentation/sysctl/fs.txt | 30 ++++++++++++++++++++++++
>  fs/namei.c                  | 56 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h          |  1 +
>  kernel/sysctl.c             |  9 ++++++++
>  4 files changed, 96 insertions(+)
> 
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index f3cf2cd..7f24b4f 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -37,6 +37,7 @@ Currently, these files are in /proc/sys/fs:
>  - protected_fifos
>  - protected_hardlinks
>  - protected_regular
> +- protected_sticky_child_create
>  - protected_symlinks
>  - suid_dumpable
>  - super-max
> @@ -238,6 +239,35 @@ When set to "2" it also applies to group writable sticky directories.
>  
>  ==============================================================
>  
> +protected_sticky_child_create:
> +
> +An O_CREAT open missing the O_EXCL flag in a sticky directory is,
> +often, a bug or a synthom of the fact that the program is not

s/synthom/symptom

> +using appropriate procedures to access sticky directories.
> +This protection allow to detect and possibly block these unsafe

Perhaps

 This protection allows us to detect, and possibly block, these unsafe

> +open invocations, even if the files don't exist yet.
> +Though should be noted that, sometimes, it's OK to open a file

Perhaps

 +Although it should be noted, sometimes it's OK to open a file

(I looked up 'although' vs 'though' and am not quite sure on this one,
it seems to read better with 'although'. Again, apologies if this is
overly trivial.)


Hope this helps,
Tobin.
