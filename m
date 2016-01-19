Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
Date: Tue, 19 Jan 2016 11:07:31 -0800
Message-ID: <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT overflow protection
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

On Thu, Dec 17, 2015 at 12:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrote:
>> NOTE: This is a v2 submission because patch 3/5 in v1 was too large to sent
>> to kernel-hardening.  Taking that as a sign that the patch needed to be split,
>> I'm sending this version of the patchset, with the patches split more or less
>> on a per-maintainer basis (except for those in drivers/).

How's the next spin coming? It looks like we have some new real-world
examples of exploits that would have been blocked by this protection:

http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/

:)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
