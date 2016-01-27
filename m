Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jan 2016 14:11:05 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160127211105.GA41450@davidb.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
 <1453226922-16831-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453226922-16831-4-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH v4 3/8] param: convert some "on"/"off"
 users to strtobool
To: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 10:08:37AM -0800, Kees Cook wrote:

>diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>index 9cc20af58c76..f5ea98490ffa 100644
>--- a/kernel/time/tick-sched.c
>+++ b/kernel/time/tick-sched.c
>@@ -387,20 +388,14 @@ void __init tick_nohz_init(void)
> /*
>  * NO HZ enabled ?
>  */
>-static int tick_nohz_enabled __read_mostly  = 1;
>+static bool tick_nohz_enabled __read_mostly  = true;
> unsigned long tick_nohz_active  __read_mostly;
> /*
>  * Enable / Disable tickless mode
>  */

Just discovered this conflicts with a recent patch with
CONFIG_NO_HZ_COMMON:

	commit 46373a15f65fe862f31c19a484acdf551f2b442f
	Author: Jean Delvare <jdelvare@suse.de>
	Date:   Mon Jan 11 17:40:31 2016 +0100

	    time: nohz: Expose tick_nohz_enabled

kernel/time/tick-sched.c:390:6: error: conflicting types for ‘tick_nohz_enabled’
	bool tick_nohz_enabled __read_mostly = true;
	     ^
In file included from kernel/time/tick-internal.h:5:0,
                 from kernel/time/tick-sched.c:30:
include/linux/tick.h:101:12: note: previous declaration of ‘tick_nohz_enabled’ was here
	extern int tick_nohz_enabled;
	           ^

Fixing the compilation error, it compiles and boots on arm64, however
it isn't detecting the write (with the lkdtm test).  I'll continue
looking into what's preventing this.

David
