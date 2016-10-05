Reply-To: kernel-hardening@lists.openwall.com
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com> <20161004124156.GE2040@pc.thejh.net>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57F51EB3.1030605@intel.com>
Date: Wed, 5 Oct 2016 08:39:31 -0700
MIME-Version: 1.0
In-Reply-To: <20161004124156.GE2040@pc.thejh.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: Jann Horn <jann@thejh.net>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/04/2016 05:41 AM, Jann Horn wrote:
> $ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
> real	0m9.550s
> user	0m18.988s
> sys	0m0.000s
> $ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protection
> real	0m9.249s
> user	0m18.430s
> sys	0m0.004s
> $ time ./atomic_user_test 2 3 1000000000 # multi-threaded, cmpxchg protection
> real	1m47.331s
> user	3m34.390s
> sys	0m0.024s

Yikes, that does get a ton worse.  But, I guess it's good to know we
have a few choices between performant and absolutely "correct".

Do you have any explanation for "racy protection" going faster than no
protection?
