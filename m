Date: Mon, 17 Jun 2019 22:26:54 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906172225.4645462F1E@keescook>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
 <201906172157.8E88196@keescook>
 <20190617221932.7406c74b6a8114a406984b70@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617221932.7406c74b6a8114a406984b70@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 17, 2019 at 10:19:32PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2019 22:07:41 -0700 Kees Cook <keescook@chromium.org> wrote:
> 
> > This is expected to be on-by-default on Android and Chrome
> > OS. And it gives the opportunity for anyone else to use it under distros
> > too via the boot args. (The init_on_free feature is regularly requested
> > by folks where memory forensics is included in their thread models.)
> 
> Thanks.  I added the above to the changelog.  I assumed s/thread/threat/

Heh whoops, yes, "threat" was intended. Thanks! :)

-- 
Kees Cook
