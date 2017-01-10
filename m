Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
 <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com> <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 Jan 2017 12:25:35 -0800
Message-ID: <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 10, 2017 at 4:42 AM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Thanks Kees,
>>
>>
>> Welcome to the list! If you're familiar with mm areas, I'd say a great
>> place to start would be to help finish up the zero-poisoning work,
>> especially extracting the optimizations that PaX did for slabs to
>> avoid, etc.
>
> Ok so I really have no idea reg PaX and optimizations done for slab via it..
> Could you
> enlighten me pl? Point me to relevant links perhaps..

Sure thing! I would recommend downloading the latest grsecurity patchset:
https://grsecurity.net/download.php#test
(currently for a 4.8.7 kernel) and apply it there. Once you have a
tree you can examine, I would look at how CONFIG_PAX_MEMORY_SANITIZE
works, and especially note this from the security/Kconfig:

          The tradeoff is performance impact, on a single CPU system kernel
          compilation sees a 3% slowdown, other systems and workloads may vary
          and you are advised to test this feature on your expected workload
          before deploying it.

          The slab sanitization feature excludes a few slab caches per default
          for performance reasons.  To extend the feature to cover those as
          well, pass "pax_sanitize_slab=full" as kernel command line parameter.

          To reduce the performance penalty by sanitizing pages only, albeit
          limiting the effectiveness of this feature at the same time, slab
          sanitization can be disabled with the kernel command line parameter
          "pax_sanitize_slab=off".

I'd like to see the mentioned excluded slab caches also done in the
kernel, along with similar kernel command line options. Additionally,
getting all the upstream stuff behind a single CONFIG (similar to
CONFIG_PAX_MEMORY_SANITIZE) would be great, instead of having to set 3
CONFIGs and 2 kernel parameters. :)

Let me know if you need more details...

-Kees

-- 
Kees Cook
Nexus Security
