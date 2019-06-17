Date: Mon, 17 Jun 2019 15:10:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-Id: <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
In-Reply-To: <20190617151050.92663-2-glider@google.com>
References: <20190617151050.92663-1-glider@google.com>
	<20190617151050.92663-2-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 17 Jun 2019 17:10:49 +0200 Alexander Potapenko <glider@google.com> wrote:

> Slowdown for the new features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)

Sanity check time.  Is anyone really going to use this?  Seriously,
honestly, for real?  If "yes" then how did we determine that?

Also, a bit of a nit: "init_on_alloc" and "init_on_free" aren't very
well chosen names for the boot options - they could refer to any kernel
object at all, really.  init_pages_on_alloc would be better?  I don't think
this matters much - the boot options are already chaotic.  But still...
