Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EB843FF.5080201@zytor.com>
Date: Mon, 07 Nov 2011 12:47:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu> <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com> <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com> <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros>
In-Reply-To: <20111107201120.GA5775@albatros>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/07/2011 12:11 PM, Vasiliy Kulikov wrote:
> 
> My statement was about static files - /proc/{interrupts,meminfo,stat,cpuinfo}.
> They don't change during the system life.  /proc/$PID/* files are indeed
> dymanic and the first link in my quoted email was about addition of such
> mount options.
> 

You didn't really get my point.  There are global nodes which are
dynamic, and more importantly the *set* changes across the system life.
 A global policy option is a lot easier to deal with for the vast
majority of users who don't need fine grain control.

	-hpa
