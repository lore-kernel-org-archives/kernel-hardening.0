Date: Fri, 31 May 2019 18:18:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
Message-Id: <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
In-Reply-To: <20190529123812.43089-3-glider@google.com>
References: <20190529123812.43089-1-glider@google.com>
	<20190529123812.43089-3-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Matthew Wilcox <willy@infradead.org>, Nick Desaulniers <ndesaulniers@google.com>, Randy Dunlap <rdunlap@infradead.org>, Sandeep Patil <sspatil@android.com>, "Serge E. Hallyn" <serge@hallyn.com>, Souptick Joarder <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 May 2019 14:38:11 +0200 Alexander Potapenko <glider@google.com> wrote:

> Print the currently enabled stack and heap initialization modes.
> 
> The possible options for stack are:
>  - "all" for CONFIG_INIT_STACK_ALL;
>  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
>  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
>  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
>  - "off" otherwise.
> 
> Depending on the values of init_on_alloc and init_on_free boottime
> options we also report "heap alloc" and "heap free" as "on"/"off".

Why?

Please fully describe the benefit to users so that others can judge the
desirability of the patch.  And so they can review it effectively, etc.

Always!

> In the init_on_free mode initializing pages at boot time may take some
> time, so print a notice about that as well.

How much time?
