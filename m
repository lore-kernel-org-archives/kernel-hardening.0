Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 17 Aug 2016 09:20:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20160817092016.30f8fc5c@gandalf.local.home>
In-Reply-To: <1471393229-27182-5-git-send-email-keescook@chromium.org>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org>
	<1471393229-27182-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 4/5] bug: Provide toggle for BUG on data corruption
To: Kees Cook <keescook@chromium.org>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 16 Aug 2016 17:20:28 -0700
Kees Cook <keescook@chromium.org> wrote:


>  EXPORT_SYMBOL(__list_add_valid);
> @@ -46,26 +41,18 @@ bool __list_del_entry_valid(struct list_head *entry)
>  	prev = entry->prev;
>  	next = entry->next;
>  
> -	if (unlikely(next == LIST_POISON1)) {
> -		WARN(1, "list_del corruption, %p->next is LIST_POISON1 (%p)\n",
> -			entry, LIST_POISON1);
> -		return false;
> -	}
> -	if (unlikely(prev == LIST_POISON2)) {
> -		WARN(1, "list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
> -			entry, LIST_POISON2);
> -		return false;
> -	}
> -	if (unlikely(prev->next != entry)) {
> -		WARN(1, "list_del corruption. prev->next should be %p, but was %p\n",
> -			entry, prev->next);
> -		return false;
> -	}
> -	if (unlikely(next->prev != entry)) {
> -		WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
> -			entry, next->prev);
> -		return false;
> -	}
> +	CHECK_DATA_CORRUPTION(next == LIST_POISON1,
> +		"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
> +		entry, LIST_POISON1);
> +	CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
> +		"list_del corruption, %p->prev is LIST_POISON2 (%p)\n",
> +		entry, LIST_POISON2);
> +	CHECK_DATA_CORRUPTION(prev->next != entry,
> +		"list_del corruption. prev->next should be %p, but was %p\n",
> +		entry, prev->next);
> +	CHECK_DATA_CORRUPTION(next->prev != entry,
> +		"list_del corruption. next->prev should be %p, but was %p\n",
> +		entry, next->prev);

OK, you totally rewrote the WARN() section anyway, thus ignore my
comment on the previous email.

-- Steve

>  	return true;
>  
>  }
