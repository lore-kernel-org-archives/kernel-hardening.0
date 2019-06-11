Date: Tue, 11 Jun 2019 13:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-Id: <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
In-Reply-To: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Shyam Saini <shyam.saini@amarulasolutions.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, keescook@chromium.org, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, mayhs11saini@gmail.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:

> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
> 
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h
> 
> In favour of FIELD_SIZEOF, this patch also deprecates other two similar
> macros sizeof_field and SIZEOF_FIELD.
> 
> For code compatibility reason, retain sizeof_field macro as a wrapper macro
> to FIELD_SIZEOF

As Alexey has pointed out, C structs and unions don't have fields -
they have members.  So this is an opportunity to switch everything to
a new member_sizeof().

What do people think of that and how does this impact the patch footprint?
