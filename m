Date: Thu, 22 Feb 2018 19:45:41 +0100
From: Emese Revfy <re.emese@gmail.com>
Subject: Re: [PATCH 20/23] gcc-plugins: always build plugins with C++
Message-Id: <20180222194541.35076c5b2166879a8d5d234a@gmail.com>
In-Reply-To: <1518806331-7101-21-git-send-email-yamada.masahiro@socionext.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
	<1518806331-7101-21-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <michal.lkml@markovi.net>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.orgkeescook@chromium.orgkernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 17 Feb 2018 03:38:48 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> If the target compiler is GCC 4.8 or newer, plugins are compiled with
> HOSTCXX.  Otherwise, gcc-plugin.sh will select HOSTCC or HOSTCXX.
> 
> To simpily things, let's decide GCC 4.8 is the requirement for GCC
> pulgins.  With this, plugins are always built with HOSTCXX.  This is a
> feature of advanced users, so this requirement whould not be not a big
> issue.

I disagree with such a decision. I think the gcc plugins should compile
with older version because the kernel can be compiled with them too.
The distros use these older versions as well and I can very well imagine
that new plugins will extend these with backported features such as
my sancov plugin.

-- 
Emese
