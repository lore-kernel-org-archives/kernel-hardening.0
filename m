References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
From: Pavel Vasilyev <dixlor@gmail.com>
Message-ID: <eaac83ad-083d-f6b1-383f-e20e73ab7e1c@gmail.com>
Date: Wed, 22 Nov 2017 15:03:24 +0300
MIME-Version: 1.0
In-Reply-To: <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



22.11.2017 11:01, Salvatore Mesoraca пишет:
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
> +using appropriate procedures to access sticky directories.
> +This protection allow to detect and possibly block these unsafe
> +open invocations, even if the files don't exist yet.
> +Though should be noted that, sometimes, it's OK to open a file
> +with O_CREAT and without O_EXCL (e.g. shared lock files based
> +on flock()), for this reason values above 2 should be set
> +with care.
> +
> +When set to "0" the protection is disabled.
> +
> +When set to "1", notify about O_CREAT open missing the O_EXCL flag
> +in world writable sticky directories.
> +
> +When set to "2", notify about O_CREAT open missing the O_EXCL flag
> +in world or group writable sticky directories.
> +
> +When set to "3", block O_CREAT open missing the O_EXCL flag
> +in world writable sticky directories and notify (but don't block)
> +in group writable sticky directories.
> +
> +When set to "4", block O_CREAT open missing the O_EXCL flag
> +in world writable and group writable sticky directories.

May be add:

When set to "X", notify O_CREAT open missing the O_EXCL flag
in world writable sticky directories and notify in group
writable sticky directories.
