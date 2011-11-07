Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EB82F08.8060209@zytor.com>
Date: Mon, 07 Nov 2011 11:18:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu> <20111107190112.GA3732@albatros>
In-Reply-To: <20111107190112.GA3732@albatros>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/07/2011 11:01 AM, Vasiliy Kulikov wrote:
> 
> What's wrong with old good DAC?  You can create a group "sysinfo", do
> "chown sysinfo /proc/interrupts", and add the permitted users to the
> group.  If you need to give different access levels to different interrupts,
> you need another /proc/interrupts design, it does nothing with DAC vs. LSM.
> 

I would like to propose that we add a mount option to procfs, and
possibly sysfs, called, say, admingrp.  These kinds of files then get
restricted to the admingrp (defaulting to gid 0 if no admingrp is
provided).  Historically on Unix there has been a group of people
(usually "adm", but sometimes "log") who are allowed to read (but not
write) the log files, which also contains potentially sensitive information.

The current Linux trend seems to be do instead force those users to
become root constantly, which is *not* helping the situation.

	-hpa
