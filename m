Date: Fri, 26 Apr 2019 14:14:47 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
In-Reply-To: <20190418154208.131118-2-glider@google.com>
Message-ID: <0100016a59ffa618-56d49996-ecb0-481c-88c3-380495651623-000000@email.amazonses.com>
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 18 Apr 2019, Alexander Potapenko wrote:

> This option adds the possibility to initialize newly allocated pages and
> heap objects with zeroes. This is needed to prevent possible information
> leaks and make the control-flow bugs that depend on uninitialized values
> more deterministic.
>
> Initialization is done at allocation time at the places where checks for
> __GFP_ZERO are performed. We don't initialize slab caches with
> constructors to preserve their semantics. To reduce runtime costs of
> checking cachep->ctor we replace a call to memset with a call to
> cachep->poison_fn, which is only executed if the memory block needs to
> be initialized.

Just check for a ctor and then zero or use whatever pattern ? Why add a
new function?
