Subject: Re: [PATCH 21/23] gcc-plugins: move GCC version check for PowerPC to
 Kconfig
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
 <1518806331-7101-22-git-send-email-yamada.masahiro@socionext.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Thu, 22 Feb 2018 16:04:21 +1100
MIME-Version: 1.0
In-Reply-To: <1518806331-7101-22-git-send-email-yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <6805fb77-23b9-7880-13f1-5d082d5c1599@au1.ibm.com>
To: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <michal.lkml@markovi.net>, Ulf Magnusson <ulfalizer@gmail.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>, Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 17/02/18 05:38, Masahiro Yamada wrote:
> For PowerPC, GCC 5.2 is the requirement for GCC plugins.  Move the
> version check to Kconfig, and remove the ugly checker.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

The old checker was as non-ugly as I could make it. :)

Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
