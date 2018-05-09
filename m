Date: Thu, 10 May 2018 05:21:37 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 1/3] big key: get rid of stack array allocation
In-Reply-To: <alpine.LRH.2.21.1805100519200.12749@namei.org>
Message-ID: <alpine.LRH.2.21.1805100520100.12749@namei.org>
References: <20180424202639.19830-1-tycho@tycho.ws> <CAGXu5jLL7NeX+zUNqcYW_LDF87CPg-5Z4R5+FZ5uPDT-sTisng@mail.gmail.com> <alpine.LRH.2.21.1805100519200.12749@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 10 May 2018, James Morris wrote:

> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > James, are these something you can take into your tree?
> 
> Sure!

Although, normally, these would likely come in to mine via David's tree.  

Please do that unless there's a special case here.


-- 
James Morris
<jmorris@namei.org>
