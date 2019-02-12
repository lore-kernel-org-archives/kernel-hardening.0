MIME-Version: 1.0
References: <cover.1549927666.git.igor.stoppa@huawei.com> <CAGXu5j+n3ky2dOe4F+VyneQsM4VJbGPUw+DO55NkxxPhKzKHag@mail.gmail.com>
 <25bf3c63-c54c-f7ea-bec1-996a2c05d997@gmail.com> <CAGXu5jLqmYRUVLb7-jPsN4onO5UNH+D6qOF=9TOiVjJa-=DnZQ@mail.gmail.com>
 <CAH2bzCRZ5xYOT0R8piqZx4mSGj1_8fNG=Ce4UU8i6F7mYD9m9Q@mail.gmail.com>
 <CAGXu5jLRJZuWjnwEuK=7AMeCrj-eioVGksPL9dE9pbzHM=+Rmg@mail.gmail.com> <29cd9541-9af2-fc1c-c264-f4cb9c29349a@gmail.com>
In-Reply-To: <29cd9541-9af2-fc1c-c264-f4cb9c29349a@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Feb 2019 14:39:02 -0800
Message-ID: <CAGXu5jJyWb7aTJpDfBPD3GqMmNaJVT0pajdrPV93xnLoOa=0Vw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/12] hardening: statically allocated protected memory
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 11:09 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
> wr_assign() does just that.
>
> However, reading again your previous mails, I realize that I might have
> misinterpreted what you were suggesting.
>
> If the advice is to have also a default memset_user() which relies on
> put_user(), but do not activate the feature by default for every
> architecture, I definitely agree that it would be good to have it.
> I just didn't think about it before.

Yeah, I just mean you could have an arch-agnostic memset_user() implementation.

> But I now realize that most likely you were just suggesting to have
> full, albeit inefficient default support and then let various archs
> review/enhance it. I can certainly do this.

Right.

> Regarding testing I have a question: how much can/should I lean on qemu?
> In most cases the MMU might not need to be fully emulated, so I wonder
> how well qemu-based testing can ensure that real life scenarios will work.

I think qemu lets you know if it works (kvm is using the real MMU),
and baremetal will give you more stable performance numbers.

-- 
Kees Cook
