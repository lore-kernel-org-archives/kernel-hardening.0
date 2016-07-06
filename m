Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Jul 2016 18:45:34 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160706184534.093e2d88d24edc324b8bb266@gmail.com>
In-Reply-To: <201607050753.OGfEuCrv%fengguang.wu@intel.com>
References: <20160705014315.c44b7c41fcb6900e10d9f4a2@gmail.com>
	<201607050753.OGfEuCrv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 3/3] Constify some function parameters
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 5 Jul 2016 07:58:04 +0800
kbuild test robot <lkp@intel.com> wrote:

> All warnings (new ones prefixed by >>):
> 
>    drivers/isdn/hisax/config.c: In function 'VHiSax_putstatus':
> >> drivers/isdn/hisax/config.c:688:5: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>       p = fmt;

Hi,

Thanks for the report, I resent "[PATCH v2 3/3] Constify some function parameters" with the fix.

-- 
Emese
