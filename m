MIME-Version: 1.0
References: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
In-Reply-To: <CALS6=qX5TyXFjVnJiamaBhVrfLa0_LYkjH9iN2-WKpVwM0WnGA@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Sun, 9 Dec 2018 08:30:13 +0800
Message-ID: <CACXcFmmgG0vLSO744RqMaSO-1BnTouqkZVNRH3+o45bJfM7JOg@mail.gmail.com>
Subject: Re: dynamically allocating memory in the kernel
Content-Type: text/plain; charset="UTF-8"
To: cartercheng@gmail.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 6, 2018 at 4:46 AM Carter Cheng <cartercheng@gmail.com> wrote:

> I was wondering if someone here could help me understand something about the kernel for a project I am working on tracking dynamically allocated memory. How many ways are there to dynamically allocate memory in the kernel presently? I know of 4.
>
> get_free_pages family of functions
> kmalloc family (including vmalloc)
> slab allocation
> mempools.
>
> Are there others? I am trying to track them all down so I have comprehensively know when all allocations occur and all "frees".

You should also look at uses of alloca(3) which dynamically allocates
memory on the stack, automatically freed when the function returns.
Some programmers prefer this to other methods, mainly because it
reduces chances of unfreed memory creating memory leaks. Others
dislike it because it is not in any C standard (I think it was
originally a GNU extension but some other compilers now support it) so
it may limit portability. Some consider it dangerous because some
usages (e.g. in a recursive function) may grow a huge stack; I am not
sure how this interacts with kernel limits on stack size.
