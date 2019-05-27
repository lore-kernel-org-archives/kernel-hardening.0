Subject: Re: [PATCH v7 11/12] x86/paravirt: Adapt assembly for PIE support
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-12-thgarnie@chromium.org>
From: Juergen Gross <jgross@suse.com>
Message-ID: <1b53b8eb-5dd3-fb57-d8db-06eedd0ce49f@suse.com>
Date: Mon, 27 May 2019 07:47:10 +0200
MIME-Version: 1.0
In-Reply-To: <20190520231948.49693-12-thgarnie@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@chromium.org>, kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 21/05/2019 01:19, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> if PIE is enabled, switch the paravirt assembly constraints to be
> compatible. The %c/i constrains generate smaller code so is kept by
> default.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Acked-by: Juergen Gross <jgross@suse.com>


Juergen
