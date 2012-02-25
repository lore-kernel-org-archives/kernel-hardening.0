Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 25 Feb 2012 07:56:53 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120225035653.GA5294@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros> <20120221145653.GA22597@openwall.com> <20120224005613.GA32733@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224005613.GA32733@openwall.com>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2012 at 04:56:13AM +0400, Solar Designer wrote:
> 1. The grsecurity patch for 2.6.32.x appears to need the counter
> increment introduced into fs/compat.c: compat_do_execve().  It is
> currently missing that, so I guess the protection is bypassable on
> 64-bit kernels with 32-bit syscall wrappers present (only if the system
> also has a suitable 32-bit SUID/SGID/fscaps-enabled binary).

Fixed in grsecurity-2.9-2.6.32.57-201202242017.patch.

> 2. /proc/<pid>/mem appears to be excluded from this protection - any
> special reason why?  I expected it to be one of the primary targets of
> this protection.

OK, my guess is that this is because mem_read() uses struct file,
whereas the exec_id field is currently only implemented for seq_file.

Instead, grsecurity's mem_read() currently has:

+	// XXX: temporary workaround
+	if (!task_dumpable(task) && task == current) {
+		ret = -EACCES;
+		goto out;
+	}

> 3. These grsecurity patch revisions actually include a newer revision of
> distros_should_sponsor_me_for_doing_their_jobs.patch.  Notably, copying
> of exec_id has been added to kernel/fork.c: copy_process().  I wonder
> why such explicit copying was needed and whether it is possibly a no-op
> given that this same function does:
> 
> 	p = dup_task_struct(current);

The explicit copying of exec_id is dropped in
grsecurity-2.9-2.6.32.57-201202242017.patch.

> I'd appreciate any comments.

Got no comments, but the code changes suffice. ;-)

I am now getting some of this stuff into the RHEL5'ish kernels that we
use on Owl.

Thanks,

Alexander
