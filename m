Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 14 Jun 2011 12:32:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110614083222.GA7973@albatros>
References: <20110603200011.GA737@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603200011.GA737@openwall.com>
Subject: [kernel-hardening] Re: add mount options to sysfs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jun 04, 2011 at 00:00 +0400, Solar Designer wrote:
> Also, I see no need for the uid= option.  Maybe leave just gid= and
> umask= for sysfs, debugfs, and configfs (pipacs reminded me of this one).

While I've implemented gid= and umask= for sysfs as mount options, and
for debugfs & configfs as sysctl variables (as they are not
per-namespace, but global to the kernel), I think it makes much sense to
implement CONFIG_{SYSFS,DEBUG_FS,CONFIGFS_FS}_{UMASK,GID} to be able to
control permissions of files already created before userspace is able to
change default permissions.  Without configurable default umask/gid via
CONFIG_* one should use "chmod -R /sys/" to alter already created files'
perms, which is a bit inconsistent.

Actual restrictions are simple, but sysctl handler for octal values
(umask) and support of octal CONFIG_* values are needed.  The former 
already exists, but witout octal printing.  You may do:

echo '0007' > /proc/sys/debug/debugfs_umask

and it is parsed correctly.  But output will be decimal.

For CONFIG_*_UMASK one may not define octal values (more than 7), and
numerics beginning from "0" are not parsed at all.

sysctl part is not hard, but for CONFIG_ parsing I have to dive into
kbuild sources, which I didn't touch yet at all.  Looking at the number
of places where e.g. S_HEX is used (parsing of hex values) I suppose it
will be time consuming task.


So, I think sysfs/debugfs/configfs umask=/gid= may be defered until all
obviously necessary hardening features are applied into the upstream or
at least discussed.

Thanks,

-- 
Vasiliy
