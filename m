Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 16 Jan 2017 14:23:02 +0100
Message-Id: <1484572984-13388-1-git-send-email-djalal@gmail.com>
Subject: [kernel-hardening] [PATCH v4 0/2] procfs/tasks: introduce per-task procfs hidepid= field
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Djalal Harouni <tixxdz@gmail.com>

Hi,

I'm sending this series again based on Lafcadio's previous patches.
I have also fixed some issues and tested the code.

This adds a new per-task hidepid= flag that is honored by procfs when
presenting /proc to the user, in addition to the existing hidepid= mount
option.

One suggested change to add 'ns_capable(CAP_SYS_ADMIN)||no_new_privs' test
before setting the hidepid was not included in this series, however I
can add it. This change was not incorporated since it may be good for
some setuid or even file capabilities programs to not access /proc, yes this
may influence setuid programs but I am not sure if this is really a
problem in this case. As stated I can add it if requested. Thanks!


v4 changes:
Patch 0001 procfs: use an enum for possible hidepid values
        * Was already acked and proposed to be added to -mm branch.

Patch 0002 procfs/tasks: add a simple per-task procfs hidepid= field
        * Document HidePid in Documentation/filesystem/proc.txt
        * Switch to max() as suggested by Kees Cook.
        * Fix compiler warnings
        * Check all prctl() arguments and fail if unused ones are set.
        * Make PR_GET_HIDEPID return the task hidpid value as a result
          of prctl() syscall.
