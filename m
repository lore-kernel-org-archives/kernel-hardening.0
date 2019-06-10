Date: Mon, 10 Jun 2019 14:32:47 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 00/12] x86: PIE support to extend KASLR randomization
Message-ID: <201906101432.B642E297F@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>, Thomas Garnier <thgarnie@google.com>, Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Feng Tang <feng.tang@intel.com>, Jan Beulich <JBeulich@suse.com>, Maran Wilson <maran.wilson@oracle.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 20, 2019 at 04:19:25PM -0700, Thomas Garnier wrote:
> Splitting the previous serie in two. This part contains assembly code
> changes required for PIE but without any direct dependencies with the
> rest of the patchset.

Thanks for doing this! It should be easier to land the "little" fixes so
there's less to review for the big PIE changes down the road.

-- 
Kees Cook
