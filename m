Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 25 Jun 2011 22:52:34 +0200
From: Willy Tarreau <w@1wt.eu>
Message-ID: <20110625205234.GA8743@1wt.eu>
References: <20110622095341.GA3353@albatros> <1308760683.10423.16.camel@Joe-Laptop> <20110622191022.66135615@lxorguk.ukuu.org.uk> <20110622190739.GB14351@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622190739.GB14351@albatros>
Subject: [kernel-hardening] Re: [Security] [PATCH] kernel: escape non-ASCII and control characters in printk()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, security@kernel.org, kernel-hardening@lists.openwall.com, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Vasiliy,

On Wed, Jun 22, 2011 at 11:07:39PM +0400, Vasiliy Kulikov wrote:
> The final check should be:
> 
>     if (iscntrl(c) && (c != '\n') && (c != '\t'))
> 
> Any comments against this variant?

In fact, I'm not sure we're adding that much protection with such a check
because as long as the '\n' is allowed, it's easy to fake logs. For instance :

$ cd /tmp
$ echo "main() { *(int*)0=0; }" | gcc -xc -o fail -
$ ln -s fail $'Oops: 000\nklogd'
$ ./Oops*
$ dmesg|tail -2
Oops: 000
klogd[1927]: segfault at 0 ip 0000000008048337 sp 00000000ffb54ba4 error 6 in fail[8048000+1000]
$

In an ideal world, only \n should be escaped since it's the only delimitor,
and klogd would get the raw logs with lines correctly sequenced. Other
characters should probably be escaped before going to log files if those
files are supposed to be readable on a terminal.

But I recall it was not possible to escape \n when we worked on the subject
several years ago on 2.4, because some drivers used to send multi-line logs
in a single printk().

The fundamental issue we're facing is that neither inputs nor outputs have
been clearly typed in the past. I tend to consider that a log file is readable
by "tail -f" and a such should not contain dangerous chars, however I also
tend to prefer sending raw logs over the network when they are archived by
different means. In the end it makes sense for the kernel and klogd to
exchange raw logs and syslogd should encode them when pushing them to a
file.

Best regards,
Willy
