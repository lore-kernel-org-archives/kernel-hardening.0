Message-ID: <1496665366.343.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 05 Jun 2017 08:22:46 -0400
In-Reply-To: <1496642591-1373-1-git-send-email-bhsharma@redhat.com>
References: <1496642591-1373-1-git-send-email-bhsharma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] powerpc: Increase ELF_ET_DYN_BASE to
 1TB for 64-bit applications
To: Bhupesh Sharma <bhsharma@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: bhupesh.linux@gmail.com, Anton Blanchard <anton@samba.org>, Daniel Cashman <dcashman@android.com>, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

Rather than doing this, the base should just be split for an ELF
interpreter like PaX. It makes sense for a standalone executable to be
as low in the address space as possible. Doing that ASAP fixes issues
like this and opens up the possibility of fixing stack mapping ASLR
entropy on various architectures. It should be a pretty small change.
