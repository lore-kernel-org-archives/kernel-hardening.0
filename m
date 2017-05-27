MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170527084246.GB26844@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-12-git-send-email-keescook@chromium.org> <20170527084246.GB26844@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 27 May 2017 13:03:23 -0700
Message-ID: <CAGXu5jKrha8-dU8vjr1U-hadZdaKrztXuo5iJLDXeBWHZS1ajw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 11/20] randstruct: Disable randomization of ACPICA structs
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 27, 2017 at 1:42 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 26, 2017 at 01:17:15PM -0700, Kees Cook wrote:
>> Since the ACPICA source is maintained externally to the kernel, we can
>> neither switch it to designated initializers nor mark it
>> __no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
>> designated initialization, explicitly skip it in the plugin.
>>
>> [1] https://github.com/acpica/acpica/pull/248
>
> I'd just overried the ACPIA bullshit process and just include these
> changes, as they are a major improvement independent of any
> reandomization.

Well... I'd rather not. It's been explicitly NAKed by them already,
which is why I sent the upstream solution (though it's being ignored
currently).

I don't want this to block randstruct any longer, so that's why I took
a whitelisting approach here.

-Kees

-- 
Kees Cook
Pixel Security
