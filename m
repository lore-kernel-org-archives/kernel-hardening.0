MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170620065631.GA25354@infradead.org>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
 <1497905801-69164-4-git-send-email-keescook@chromium.org> <20170620065631.GA25354@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 12:25:53 -0700
Message-ID: <CAGXu5jLkvqbV1=xGrvwLZPiAbswA6M5C3BB0M5MytRabLtEfLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/4] randstruct: Disable randomization of ACPICA structs
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 11:56 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 19, 2017 at 01:56:40PM -0700, Kees Cook wrote:
>> Since the ACPICA source is maintained externally to the kernel, we can
>> neither switch it to designated initializers nor mark it
>> __no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
>> designated initialization, explicitly skip it in the plugin.
>
> NAK.  ACPI has no business rejecting kernel changes to start with, but
> independent of that your patch was complete garbage anyway.

While I don't disagree with your opinion about ACPICA's inclusion in
the kernel, that isn't a battle I want to have. The ACPI maintainers
have a certain way of doing things, and what I need to change is tiny
compared to that.

> There is no need for function pointers here, please include the patch
> below instead:

Can you send the patch to https://github.com/acpica/acpica ? My change
was finally accepted, so this whole issue will go away on the next
refresh. Until then, I don't want to block the entire automatic
structure selection logic of randstruct on a three-function table. :)

Given that it's a tiny exclusion for randstruct, and there is already
a path in motion to fix it, I think this patch is trivial and
sufficient.

-Kees

-- 
Kees Cook
Pixel Security
