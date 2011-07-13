Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E1D2EF9.3090201@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 14:36:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110707075610.GA3411@albatros> <20110707081930.GA4393@albatros> <20110712132723.GA3193@albatros>
In-Reply-To: <20110712132723.GA3193@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: segoon@openwall.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, davem@davemloft.net, kernel-hardening@lists.openwall.com, jslaby@suse.cz, jmorris@namei.org, neilb@suse.de, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

(2011/07/12 22:27), Vasiliy Kulikov wrote:
> The patch http://lkml.org/lkml/2003/7/13/226 introduced a RLIMIT_NPROC
> check in set_user() to check for NPROC exceeding via setuid() and
> similar functions.  Before the check there was a possibility to greatly
> exceed the allowed number of processes by an unprivileged user if the
> program relied on rlimit only.  But the check created new security
> threat: many poorly written programs simply don't check setuid() return
> code and believe it cannot fail if executed with root privileges.  So,
> the check is removed in this patch because of too often privilege
> escalations related to buggy programs.
> 
> The NPROC can still be enforced in the common code flow of daemons
> spawning user processes.  Most of daemons do fork()+setuid()+execve().
> The check introduced in execve() enforces the same limit as in setuid()
> and doesn't create similar security issues.
> 
> Similar check was introduced in -ow patches.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

BSD folks tell me NetBSD has the exactly same hack (ie check at exec instead
setuid) since 2008. Then, I think this is enough proved safer way.

http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/kern/kern_exec.c?rev=1.316&content-type=text/x-cvsweb-markup&only_with_tag=MAIN

Thx.
