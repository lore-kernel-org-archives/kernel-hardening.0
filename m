Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <7102975e-88a5-3555-21e1-f07d595bc235@gmail.com>
References: <20160611161212.GA29370@www.outflux.net> <20160611162926.GL12567@windriver.com>
 <20160613001244.b4b3c675d59e3ad3d8d656a4@gmail.com> <CAGXu5jJ_+azG6H0tB7W0mJTUzXp18Y7qN7dx7EEKng+0nO-dig@mail.gmail.com>
 <20160613021831.9a79c5c82d1511e572023ed6@gmail.com> <7102975e-88a5-3555-21e1-f07d595bc235@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Jun 2016 13:11:37 -0700
Message-ID: <CAGXu5jLYYg8QdWy0nMLLV4e4=xz7G2U7CBQjsAd5Q5PfZd48ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: disable under COMPILE_TEST
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Michal Marek <mmarek@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 13, 2016 at 11:32 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-06-12 20:18, Emese Revfy wrote:
>>
>> On Sun, 12 Jun 2016 15:25:39 -0700
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>> I don't like this because it means if someone specifically selects
>>> some plugins in their .config, and the headers are missing, the kernel
>>> will successfully compile. For many plugins, this results in a kernel
>>> that lacks the requested security features, and that I really do not
>>> want to have happening. I'm okay leaving these disabled for compile
>>> tests for now. We can revisit this once more distros have plugins
>>> enabled by default.
>>
>>
>> You are right. Your patch is safer.
>>
> Why not make it so that if COMPILE_TEST is enabled, the build warns if it
> can't find the headers, otherwise it fails?  That way, people who are doing
> all*config builds but don't have the headers will still get some build
> coverage, and the people who are enabling it as a security feature will
> still get build failures.

I don't see a clear way to do this, but if you can find a way to make
that happen, please send a patch! :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
