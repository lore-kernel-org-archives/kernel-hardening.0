References: <alpine.LRH.2.20.1702131631490.8914@namei.org>
 <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
 <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <9a8a38e0-d502-d6fc-5ea6-77f45539eba6@redhat.com>
Date: Mon, 13 Feb 2017 08:26:56 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/13/2017 06:59 AM, Kees Cook wrote:
> On Mon, Feb 13, 2017 at 2:33 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>> James Morris wrote:
>>> As the regsitration of LSMs is performed during init and then does
>>> not change, we can mark all of the regsitration hooks as __ro_after_init.
>>>
>>> Signed-off-by: James Morris <james.l.morris@oracle.com>
>>
>> This patch makes LKM based LSMs (e.g. AKARI) impossible.
>> I'm not happy with this patch.
> 
> LKM based LSMs don't exist yet, and when they do, we may also have the
> "write rarely" infrastructure done, which LKM based LSMs can use to
> update the structures.
> 
> -Kees
> 

Is someone actually working on the write rarely patches? If a version
has been sent out, I don't recall seeing it.

Thanks,
Laura
