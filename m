MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170527084748.GA11558@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-15-git-send-email-keescook@chromium.org> <20170527084748.GA11558@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 27 May 2017 13:10:44 -0700
Message-ID: <CAGXu5jKiMDQGBZbea0=Pz03G=8SSUvsTrQq=sMQLwWZ_SMrRxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 14/20] drm/amd/powerplay: Use designated initializers
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Eric Huang <JinHuiEric.Huang@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 27, 2017 at 1:47 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +     { .isFunctionNeededInRuntimeTable = NULL,
>> +       .tableFunction = tf_vega10_thermal_initialize },
>
> I'd say drop the NULL initializations as they are implicit anyway.

Oh, dur, yeah, I'll improve this.

-Kees

-- 
Kees Cook
Pixel Security
