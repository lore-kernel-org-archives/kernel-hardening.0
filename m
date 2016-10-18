Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161017134413.GK29095@leverpostej>
References: <1469630746-32279-1-git-send-email-jeffv@google.com> <20161017134413.GK29095@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Oct 2016 13:48:30 -0700
Message-ID: <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 17, 2016 at 6:44 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> Attempt to revive discussions below...
>
> On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
>> When kernel.perf_event_paranoid is set to 3 (or greater), disallow
>> all access to performance events by users without CAP_SYS_ADMIN.
>>
>> This new level of restriction is intended to reduce the attack
>> surface of the kernel. Perf is a valuable tool for developers but
>> is generally unnecessary and unused on production systems. Perf may
>> open up an attack vector to vulnerable device-specific drivers as
>> recently demonstrated in CVE-2016-0805, CVE-2016-0819,
>> CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843. This new level of
>> restriction allows for a safe default to be set on production systems
>> while leaving a simple means for developers to grant access [1].
>>
>> This feature is derived from CONFIG_GRKERNSEC_PERF_HARDEN by Brad
>> Spengler. It is based on a patch by Ben Hutchings [2]. Ben's patches
>> have been modified and split up to address on-list feedback.
>>
>> kernel.perf_event_paranoid=3 is the default on both Debian [2] and
>> Android [3].
>
> While people weren't particularly happy with this global toggle
> approach, my understanding from face-to-face discussions at LSS2016 was
> that people were happy with a more scoped restriction (e.g. using
> capabilities or some other access control mechanism), but no-one had the
> time to work on that.
>
> Does that match everyone's understanding, or am I mistaken?

That's correct: some kind of finer-grain control would be preferred to
the maintainer, but no one has had time to work on it. (The =3 sysctl
setting present in Android, Debian, and Ubuntu satisfies most people.)

-Kees

-- 
Kees Cook
Nexus Security
