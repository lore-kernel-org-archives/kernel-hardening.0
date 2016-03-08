Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLEizJK=YBrErDZGbANwWe2AdnsRPLAQL=nvnuCC_Q8LQ@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
 <20160307000730.5f5b379d0e88b97fc0112c8e@gmail.com> <CAGXu5jLEizJK=YBrErDZGbANwWe2AdnsRPLAQL=nvnuCC_Q8LQ@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 8 Mar 2016 11:54:29 +0100
Message-ID: <CACT4Y+axEAF=m+=15ymTzveY9uWOLQsBoDkzKY-K0XnTngKwOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 5/5] Add sancov plugin
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 7, 2016 at 10:07 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Mar 6, 2016 at 3:07 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> The sancov gcc plugin inserts a __sanitizer_cov_trace_pc() call
>> at the start of basic blocks.
>>
>> This plugin is a helper plugin for the kcov feature. It supports
>> all gcc versions with plugin support (from gcc-4.5 on).
>> It is based on the gcc commit "Add fuzzing coverage support" by Dmitry Vyukov
>> (https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296).
>
> Very cool! Dmitry, is this something you could put to good use?

I am using gcc with sancov as a regular pass, so I don't a good use
for this right now. Maybe it will help with deployment for Android. I
don't know. Though, it will require backporting this plugin support.
