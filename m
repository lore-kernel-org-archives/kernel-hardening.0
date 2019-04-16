Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
References: <20190412124501.132678-1-glider@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <35935775-1c0d-6016-5bb3-0abee65a7492@suse.cz>
Date: Tue, 16 Apr 2019 10:30:20 +0200
MIME-Version: 1.0
In-Reply-To: <20190412124501.132678-1-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/12/19 2:45 PM, Alexander Potapenko wrote:
> +config INIT_HEAP_ALL
> +	bool "Initialize kernel heap allocations"

Calling slab and page allocations together as "heap" is rather uncommon
in the kernel I think. But I don't have a better word right now.

> +	default n
> +	help
> +	  Enforce initialization of pages allocated from page allocator
> +	  and objects returned by kmalloc and friends.
> +	  Allocated memory is initialized with zeroes, preventing possible
> +	  information leaks and making the control-flow bugs that depend
> +	  on uninitialized values more deterministic.
> +
>  config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>  	bool "Report forcefully initialized variables"
>  	depends on GCC_PLUGIN_STRUCTLEAK
> 
