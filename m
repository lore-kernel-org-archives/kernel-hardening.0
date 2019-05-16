Date: Wed, 15 May 2019 18:02:00 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
Message-ID: <201905151752.2BD430A@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-3-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-3-glider@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com, kernel-hardening@lists.openwall.com, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> Add tests for heap and pagealloc initialization.
> These can be used to check init_on_alloc and init_on_free implementations
> as well as other approaches to initialization.

This is nice! Easy way to test the results. It might be helpful to show
here what to expect when loading this module:

with either init_on_alloc=1 or init_on_free=1, I happily see:

	test_meminit: all 10 tests in test_pages passed
	test_meminit: all 40 tests in test_kvmalloc passed
	test_meminit: all 20 tests in test_kmemcache passed
	test_meminit: all 70 tests passed!

and without:

	test_meminit: test_pages failed 10 out of 10 times
	test_meminit: test_kvmalloc failed 40 out of 40 times
	test_meminit: test_kmemcache failed 10 out of 20 times
	test_meminit: failures: 60 out of 70


> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>

note below...

> [...]
> diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> new file mode 100644
> index 000000000000..67d759498030
> --- /dev/null
> +++ b/lib/test_meminit.c
> @@ -0,0 +1,205 @@
> +// SPDX-License-Identifier: GPL-2.0
> [...]
> +module_init(test_meminit_init);

I get a warning at build about missing the license:

WARNING: modpost: missing MODULE_LICENSE() in lib/test_meminit.o

So, following the SPDX line, just add:

MODULE_LICENSE("GPL");

-- 
Kees Cook
