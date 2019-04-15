Subject: Re: [PATCH v2 1/3] security: Create "kernel hardening" config area
References: <20190411180117.27704-1-keescook@chromium.org>
 <20190411180117.27704-2-keescook@chromium.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <947dbe9a-3444-6fe4-9f79-f8f210da8960@linux.com>
Date: Mon, 15 Apr 2019 19:44:09 +0300
MIME-Version: 1.0
In-Reply-To: <20190411180117.27704-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 11.04.2019 21:01, Kees Cook wrote:
> Right now kernel hardening options are scattered around various Kconfig
> files. This can be a central place to collect these kinds of options
> going forward. This is initially populated with the memory initialization
> options from the gcc-plugins.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Hello Kees, hello everyone!

After applying this series the kernel config looks like that:

...
...
CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
...
...

What do you think about some separator between memory initialization options and
CONFIG_CRYPTO?

Best regards,
Alexander
