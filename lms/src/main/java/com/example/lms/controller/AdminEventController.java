package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.Event;
import com.example.lms.dto.User;
import com.example.lms.service.EventService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/events")
public class AdminEventController {

    @Autowired
    private EventService eventService;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("eventList", eventService.getEventList());
        return "admin/eventList";
    }

    @GetMapping("/add")
    public String addForm() {
        return "admin/eventForm";
    }

    @PostMapping("/add")
    public String add(Event event, HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        event.setUserId(loginUser.getUserId());

        eventService.addEvent(event);
        return "redirect:/admin/events";
    }

    @GetMapping("/edit")
    public String editForm(@RequestParam Long eventId, Model model) {

        model.addAttribute("event", eventService.getEvent(eventId));
        return "admin/eventEditForm";
    }

    @PostMapping("/edit")
    public String edit(Event event) {

        eventService.modifyEvent(event);
        return "redirect:/admin/events";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long eventId) {
        eventService.removeEvent(eventId);
        return "redirect:/admin/events";
    }
}