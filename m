Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Mar 2013 21:36:11 +0400
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20130304173611.GA8500@cachalot>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
 <20130303005700.GA32213@austin.hallyn.com>
 <874ngtxgt5.fsf@xmission.com>
 <CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
 <874ngsrvrh.fsf@xmission.com>
 <CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
 <87k3pnmwpk.fsf_-_@xmission.com>
 <878v63mwm3.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v63mwm3.fsf_-_@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] fs: Limit sys_mount to only request filesystem
 modules.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@google.com>, Brad Spengler <spender@grsecurity.net>, Linux Containers <containers@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>, Dave Jones <davej@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed kernel-hardening)

On Sun, Mar 03, 2013 at 23:51 -0800, Eric W. Biederman wrote:
> Modify the request_module to prefix the file system type with "fs-"
> and add aliases to all of the filesystems that can be built as modules
> to match.
> 
> A common practice is to build all of the kernel code and leave code
> that is not commonly needed as modules, with the result that many
> users are exposed to any bug anywhere in the kernel.
> 
> Looking for filesystems with a fs- prefix limits the pool of possible
> modules that can be loaded by mount to just filesystems trivially
> making things safer with no real cost.
> 
> Using aliases means user space can control the policy of which
> filesystem modules are auto-loaded by editing /etc/modprobe.d/*.conf
> with blacklist and alias directives.  Allowing simple, safe,
> well understood work-arounds to known problematic software.
> 
> This also addresses a rare but unfortunate problem where the filesystem
> name is not the same as it's module name and module auto-loading
> would not work.  While writing this patch I saw a handful of such
> cases.  The most significant being autofs that lives in the module
> autofs4.
> 
> This is relevant to user namespaces because we can reach the request
> module in get_fs_type() without having any special permissions, and
> people get uncomfortable when a user specified string (in this case
> the filesystem type) goes all of the way to request_module.
> 
> After having looked at this issue I don't think there is any
> particular reason to perform any filtering or permission checks beyond
> making it clear in the module request that we want a filesystem
> module.  The common pattern in the kernel is to call request_module()
> without regards to the users permissions.  In general all a filesystem
> module does once loaded is call register_filesystem() and go to sleep.
> Which means there is not much attack surface exposed by loading a
> filesytem module unless the filesystem is mounted.  In a user
> namespace filesystems are not mounted unless .fs_flags = FS_USERNS_MOUNT,
> which most filesystems do not set today.
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Reported-by: Kees Cook <keescook@google.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
...
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index da165f6..92567d9 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -273,7 +273,7 @@ struct file_system_type *get_fs_type(const char *name)
>  	int len = dot ? dot - name : strlen(name);
>  
>  	fs = __get_fs_type(name, len);
> -	if (!fs && (request_module("%.*s", len, name) == 0))
> +	if (!fs && (request_module("fs-%.*s", len, name) == 0))
>  		fs = __get_fs_type(name, len);
>  
>  	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {

Maybe we should divide request_module() into several functions regarding
expected caller's privileges?

- request_module() for CAP_SYS_MODULE in init_ns
- request_module_relaxed() for everybody

request_module_relaxed() is used in get_fs_type(), dev_load() and all
places where the safety of module loading is manually checked.  All old
not yet checked users of request_module() will not be triggerable from user_ns.
That's the same scheme as with capable() and ns_capable().

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
