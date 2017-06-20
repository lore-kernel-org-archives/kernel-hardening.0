References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <dc146cb5-98fc-57f9-e4c8-3e1bd6d78acf@marcan.st>
 <CAGXu5j++EC_HSjrHJ1=ax=8WMooNpd3o2U=+csUp2mgWyunsmQ@mail.gmail.com>
From: "Hector Martin \"marcan\"" <marcan@marcan.st>
Message-ID: <abfbcf83-3879-910b-aa56-30ab40e61648@marcan.st>
Date: Wed, 21 Jun 2017 05:22:40 +0900
MIME-Version: 1.0
In-Reply-To: <CAGXu5j++EC_HSjrHJ1=ax=8WMooNpd3o2U=+csUp2mgWyunsmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH RFC v2 1/1] gcc-plugins: Add stackleak
 feature erasing the kernel stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-21 04:07, Kees Cook wrote:
> On Tue, Jun 20, 2017 at 2:06 AM, Hector Martin "marcan"
> <marcan@marcan.st> wrote:
>> I know this isn't the first time I've mentioned this, but I think it bears
>> repeating that, as far as I understand the licensing (IANAL), GCC plug-ins
>> licensed as GPLv2 are in violation of the GCC license.
> 
> I continue to think that the wording is unclear and that rational
> people can come to different conclusions. To guide me I try to look at
> the intent of the license ("stay Free Software") and the decisions of
> the author ("this should be GPLv2"). Since the authors are quite clear
> about their rationale, and I don't see anything that appears to be
> trying to dodge the plugin being Free Software, I stand by my earlier
> conclusion[1].

I think this is a somewhat naive view. Even if we ignore the letter of
the license (which I do believe we shouldn't, to keep us out of legal
hot water) and focus on the spirit/intent, what is going on here has a
seriously strange smell.

For one, the GPLv2 license has been chosen *explicitly* to re-target a
licensing scheme intended to prevent usage of GCC with non-free plugins
to, instead, limit usage of the plug-in to only certain kinds of
software (namely the kernel). This was done in order to effectively use
the free plug-in as an advertisement for a (AIUI) GPLv3-licensed "full"
version that is (AIUI) distributed under a wrapper contract that
attempts to discourage redistribution (i.e. exercising the user's rights
under the license) under threat of contract discontinuation. Whether
this is legal or not (and I believe it is, at least this part of the
story), it's certainly not what the GCC authors had in mind when they
developed the plug-in interface and very much violates the intent of the
libgcc exception mechanism (which is just to discourage proprietary
plug-ins).

Additionally, the simple fact that the plug-in is not GPLv3-compatible
means it cannot be upstreamed into GCC itself. This prevents GCC itself
from benefiting from this usage of its plug-in API, and is also clearly
not what the GCC authors intend.

Ultimately, the GCC authors laid out a simple rule with their license
choice: "keep plug-ins GPLv3-compatible", and this plug-in violates that
rule - worse, does so in order to explicitly limit users' freedom. I
think it's easy to argue that this violates the spirit of free software
and the intent of the FSF.

For what it's worth, I did ask a GCC developer and he agrees with my
analysis (though obviously this is a single data point and does not
represent the view of the FSF's lawyers).

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
