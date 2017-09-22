Date: Fri, 22 Sep 2017 00:30:46 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170922073046.GA581@zzz.localdomain>
References: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
Subject: Re: [kernel-hardening] [RFC] A method to prevent priviledge
 escalation
To: =?utf-8?B?5Lit5p2R6ZuE5LiAIC8gTkFLQU1VUkHvvIxZVVVJQ0hJ?= <yuichi.nakamura.fe@hitachi.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "yamauchi@cs.okayama-u.ac.jp" <yamauchi@cs.okayama-u.ac.jp>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 22, 2017 at 02:49:59AM +0000, 中村雄一 / NAKAMURA，YUUICHI wrote:
> Hi.
> 
> As we said in Linux Security Summit 2017, 
> we would like to post a patch to prevent privilege escalation attack.
> 
> The concept is here:
> http://events.linuxfoundation.org/sites/events/files/slides/nakamura_20170831_1.pdf
> 
> This work is still work in progress and feedback is welcomed.
> Below patch works for linux-4.4.0, 
> To see that it works (try it in a safe place!), 
>  * build vulnerable kernel on Ubuntu 16.04.1 
>    source: https://launchpad.net/ubuntu/+source/linux/4.4.0-62.83
>    please enable "CONFIG_AKO" in kernel config.
>  * try a poc code for kernel vulnerability
>    https://github.com/xairy/kernel-exploits/blob/master/CVE-2017-6074/poc.c
>  * look at kernel log, you can see a log that it detected attack like below:
>  AKO: detected unauthorized change of UID. syscall=45 original: uid=1000, euid=1000, fsuid=1000, suid=1000 attempt: uid=0, euid=0, fsuid=0, suid=0
>  AKO: detected unauthorized change of gid. syscall=45 original: gid=1000, egid=1000, fsgid=1000, sgid=1000 attempt: gid=0, egid=0, fsgid=0, sgid=0
> 

You mean a method to *allow* privilege escalation?  This makes stack overflows
exploitable again, and trivially so.  Not to mention that adding one line of
code to the POC to set ->ako_sysnum circumvents this entire "security" feature.

The only way this would be even somewhat sane is if the copy of the credentials
were mapped read-only.  But even then, it wouldn't protect against exploits that
already gain arbitrary code execution (such as your example exploit) --- it
would only protect against exploits that somehow modify their cred struct
directly.  And in that case keeping the cred structs mapped readonly would
probably make more sense...
