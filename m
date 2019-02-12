MIME-Version: 1.0
References: <cover.1549927666.git.igor.stoppa@huawei.com> <CAGXu5j+n3ky2dOe4F+VyneQsM4VJbGPUw+DO55NkxxPhKzKHag@mail.gmail.com>
 <25bf3c63-c54c-f7ea-bec1-996a2c05d997@gmail.com>
In-Reply-To: <25bf3c63-c54c-f7ea-bec1-996a2c05d997@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 11 Feb 2019 16:46:56 -0800
Message-ID: <CAGXu5jLqmYRUVLb7-jPsN4onO5UNH+D6qOF=9TOiVjJa-=DnZQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/12] hardening: statically allocated protected memory
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 4:37 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
>
>
>
> On 12/02/2019 02:09, Kees Cook wrote:
> > On Mon, Feb 11, 2019 at 3:28 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
> > It looked like only the memset() needed architecture support. Is there
> > a reason for not being able to implement memset() in terms of an
> > inefficient put_user() loop instead? That would eliminate the need for
> > per-arch support, yes?
>
> So far, yes, however from previous discussion about power arch, I
> understood this implementation would not be so easy to adapt.
> Lacking other examples where the extra mapping could be used, I did not
> want to add code without a use case.
>
> Probably both arm and x86 32 bit could do, but I would like to first get
> to the bitter end with memory protection (the other 2 thirds).
>
> Mostly, I hated having just one arch and I also really wanted to have arm64.

Right, I meant, if you implemented the _memset() case with put_user()
in this version, you could drop the arch-specific _memset() and shrink
the patch series. Then you could also enable this across all the
architectures in one patch. (Would you even need the Kconfig patches,
i.e. won't this "Just Work" on everything with an MMU?)

-- 
Kees Cook
