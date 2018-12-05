MIME-Version: 1.0
References: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
In-Reply-To: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 5 Dec 2018 15:00:49 -0800
Message-ID: <CAGXu5j+Yyu+mKK=bN6Ugha06huGY06=s56XLoXRC1-2FEP89fQ@mail.gmail.com>
Subject: Re: dynamically allocating memory in the kernel
Content-Type: text/plain; charset="UTF-8"
To: Carter Cheng <cartercheng@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 5, 2018 at 12:46 PM Carter Cheng <cartercheng@gmail.com> wrote:
>
> Hello,
>
> I was wondering if someone here could help me understand something about the kernel for a project I am working on tracking dynamically allocated memory. How many ways are there to dynamically allocate memory in the kernel presently? I know of 4.
>
> get_free_pages family of functions
> kmalloc family (including vmalloc)

vmalloc is quite different from kmalloc (see below).

> slab allocation

kmalloc is a type of slab allocation, so the base parts are the same.

> mempools.
>
> Are there others? I am trying to track them all down so I have comprehensively know when all allocations occur and all "frees".

I would recommend looking at KASAN hooks (which tracks use-after-free)
to see if there are any areas you're missing.

-Kees

-- 
Kees Cook
